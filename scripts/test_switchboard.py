#!/usr/bin/env python3
"""Test script to debug switchboard GPO2 control."""
import os, sys, time, subprocess
from otii_tcp_client import otii_client
from otii_tcp_client.arc import Arc


def get_single_arc(otii):
    devs = otii.get_devices()
    if not devs:
        print("No devices found")
        sys.exit(1)
    d0 = devs[0]
    if isinstance(d0, Arc):
        return d0
    name = d0.get("name")
    device_id = otii.get_device_id(name)
    return Arc(
        {"device_id": device_id, "name": name, "type": d0.get("type", "Arc")},
        otii.connection,
    )


def main():
    server_bin = os.environ.get("OTII_SERVER_BIN", "otii_server")
    server_proc = subprocess.Popen(
        [server_bin], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    time.sleep(3)

    try:
        client = otii_client.OtiiClient()
        otii = client.connect()
        print("Connected to Otii server")

        project = otii.create_project()
        arc = get_single_arc(otii)
        arc.add_to_project()
        print(f"Device added to project")

        # Enable 5V pin for switchboard relay power
        arc.enable_5v(True)
        # Enable expansion port and set voltages
        arc.enable_exp_port(True)
        arc.set_exp_voltage(5.0)
        print(f"Exp port enabled, digital voltage = {arc.get_exp_voltage()}V")

        # Enable channels
        for ch in ("mc", "mp", "i1", "i2"):
            arc.enable_channel(ch, True)

        # Power on
        arc.set_main_voltage(3.3)
        arc.set_max_current(0.01)
        arc.set_main(True)
        print(f"Main ON, voltage = {arc.get_main_voltage()}V")
        time.sleep(1.0)

        # Test GPO2
        print("\n--- Testing GPO2 ---")
        arc.set_gpo(2, True)
        print("GPO2 = True. Is green light on? Waiting 5s...")
        time.sleep(5)

        # Check GPI states for feedback
        try:
            gpi1 = arc.get_gpi(1)
            gpi2 = arc.get_gpi(2)
            print(f"GPI1 = {gpi1}, GPI2 = {gpi2}")
        except Exception as e:
            print(f"get_gpi failed: {e}")

        arc.set_gpo(2, False)
        print("GPO2 = False")
        time.sleep(1)

        # Test GPO1
        print("\n--- Testing GPO1 ---")
        arc.set_gpo(1, True)
        print("GPO1 = True. Is green light on? Waiting 5s...")
        time.sleep(5)
        arc.set_gpo(1, False)
        print("GPO1 = False")
        time.sleep(1)

        # Test both GPOs
        print("\n--- Testing BOTH GPO1 + GPO2 ---")
        arc.set_gpo(1, True)
        arc.set_gpo(2, True)
        print("GPO1 = True, GPO2 = True. Is green light on? Waiting 5s...")
        time.sleep(5)
        arc.set_gpo(1, False)
        arc.set_gpo(2, False)
        print("Both off")

        # Cleanup
        arc.set_main(False)
        print("\nDone. Cleaned up.")

    finally:
        server_proc.terminate()


if __name__ == "__main__":
    main()
