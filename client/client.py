import asyncio
import websockets
import pyautogui


async def main():
    url = "ws://localhost:8765"
    async with websockets.connect(url) as websocket:
        print(f'Successfully connect {url}')
        char = await websocket.recv()
        pyautogui.press(char)
