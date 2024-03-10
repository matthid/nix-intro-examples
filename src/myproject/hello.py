# src/myproject/hello.py
import torch
def greet():
    print(f"Hello, World! Cuda available: {torch.cuda.is_available()}")

if __name__ == "__main__":
    greet()