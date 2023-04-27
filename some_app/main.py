import os
from dotenv import load_dotenv

def main():
    load_dotenv()

    var = os.getenv("SOME_ENV_VAR")
    print(f"Hello, {var}!")

if __name__ == "__main__":
    main()
