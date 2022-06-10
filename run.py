import asyncio
import time
import subprocess
import pyautogui
from server import server


async def main():
    await asyncio.create_task(server.main())

if __name__ == '__main__':
    asyncio.run(main())
