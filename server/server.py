import asyncio
import time
import pyautogui
import pyperclip
import websockets


async def link(websocket):
    pyautogui.hotkey('command', 'shift', 'left')
    pyautogui.hotkey('command', 'c')
    pyautogui.hotkey('right')
    await websocket.send('server:' + pyperclip.paste())


async def echo(websocket, path):
    async for message in websocket:
        print("receive message:", message)
        data = message.split(':')
        if 2 <= len(data) <= 3 and data[0] == 'client':
            if data[1] == 'link' or data[1] == 'connected':
                await link(websocket)
            elif data[1] == 'delete':
                pyautogui.hotkey('command', 'shift', 'left')
                pyperclip.copy(data[2])
                pyautogui.hotkey('command', 'v')
            else:
                pyperclip.copy(data[1])
                pyautogui.hotkey('command', 'v')


async def main():
    async with websockets.serve(echo, "192.168.0.56", 8765):
        await asyncio.Future()
