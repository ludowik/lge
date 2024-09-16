import os
import psutil


def memory():
    process = psutil.Process(os.getpid())
    return process.memory_info().rss / 1024 / 1024 #mo
