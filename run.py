import asyncio
from client import client
from server import server


async def main():
    client_task, server_task = asyncio.create_task(
        client.main()), asyncio.create_task(server.main())
    res1 = await server_task
    res2 = await client_task
    print(res1, res2)

if __name__ == '__main__':
    asyncio.run(main())
