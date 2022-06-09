import asyncio
from .client import client
from .server import server

if __name__ == '__main__':
    client_task, server_task = asyncio.create_task(
        client.main()), asyncio.create_task(server.main())
    res = await asyncio.gather(server_task, client_task)
    print(res)
