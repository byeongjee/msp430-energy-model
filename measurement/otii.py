from otii_tcp_client import otii_client
from dotenv import load_dotenv

def my_test(otii):
    pass

def main() -> None:
    load_dotenv()
    # Connect and login to Otii 3
    client = otii_client.OtiiClient()
    with client.connect() as otii:
        my_test(otii)

if __name__ == '__main__':
    main()
