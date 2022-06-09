import asyncio
import websockets
import pyautogui


async def main():
    uri = "ws://localhost:8765"
    async with websockets.connect(uri) as websocket:
        char = await websocket.recv()
        pyautogui.press(char)


if __name__ == '__main__':
    asyncio.run(main())
