import hashlib
import sys


if __name__ == '__main__':
    input_string: str = sys.argv[1]
    sha_sum: str = hashlib.sha256(input_string.encode()).hexdigest()
    print("\nThe SHA-256 sum of '{}' is:".format(input_string))
    print(sha_sum)
    print("")
