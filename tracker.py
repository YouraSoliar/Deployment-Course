import requests
import time
import argparse


def ping(address):
    try:
        response = requests.get(address)
        if response.status_code == 200:
            print(f"Ping successful: {address}")
        else:
            print(f"Ping failed: {address}")
    except requests.exceptions.RequestException as e:
        print(f"Error pinging {address}: {e}")


def main():
    parser = argparse.ArgumentParser(description="Ping virtual machines in Azure.")
    parser.add_argument("addresses", nargs="+", help="List of addresses to ping")
    parser.add_argument("--interval", type=int, default=10, help="Interval between pings in seconds")
    args = parser.parse_args()

    print(f"Pinging addresses: {args.addresses}")
    print(f"Ping interval: {args.interval} seconds")

    while True:
        for address in args.addresses:
            ping(f'http://{address}')
        time.sleep(args.interval)


if __name__ == "__main__":
    main()