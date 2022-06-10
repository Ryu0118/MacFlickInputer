import asyncio
import time
import pyautogui
import pyperclip
import websockets


async def echo(websocket, path):
    async for message in websocket:
        print("receive message:", message)
        data = message.split(':')
        if len(data) == 2 and data[0] == 'client':
            if data[1] == 'link':
                pyautogui.hotkey('command', 'shift', 'left')
                pyautogui.hotkey('command', 'c')
                pyautogui.hotkey('left')
                await websocket.send('server:' + pyperclip.paste())
            elif data[1] == 'delete':
                pyautogui.hotkey('delete')
            else:
                pyperclip.copy(message)
                pyautogui.hotkey('command', 'v')


async def main():
    async with websockets.serve(echo, "192.168.0.56", 8765):
        await asyncio.Future()
