#!/usr/bin/env python3
"""Fill the Reason Companion login form through the Chrome DevTools Protocol.

Keyboard input often does not reach Companion's Electron window under Wine/Xvfb.
Start Companion with --remote-debugging-port=9222 (see README), then:
    pip install websocket-client
    REASON_EMAIL=you@example.com python3 cdp_login.py
The password is read interactively (never stored). Nothing is sent anywhere except
to the local Companion window on 127.0.0.1.
"""
import getpass, json, os, sys, time, urllib.request
import websocket

PORT = int(os.environ.get("CDP_PORT", "9222"))
pages = json.load(urllib.request.urlopen(f"http://127.0.0.1:{PORT}/json"))
page = next(p for p in pages if p.get("type") == "page")
ws = websocket.create_connection(page["webSocketDebuggerUrl"], suppress_origin=True)
_i = 0

def call(method, params=None):
    global _i
    _i += 1
    ws.send(json.dumps({"id": _i, "method": method, "params": params or {}}))
    while True:
        r = json.loads(ws.recv())
        if r.get("id") == _i:
            return r

def ev(expr):
    return call("Runtime.evaluate", {"expression": expr, "returnByValue": True})["result"]["result"].get("value")

def fill(selector, value):
    ev(f"document.querySelector({json.dumps(selector)}).focus()")
    call("Input.insertText", {"text": value})

email = os.environ.get("REASON_EMAIL") or input("Reason Studios account email: ")
pw = getpass.getpass("Password: ")
print(ev("JSON.stringify([...document.querySelectorAll('input,button')].map(e=>[e.tagName,e.type,e.name,e.id]))"))
fill("input[type=email],input[type=text]", email)
fill("input[type=password]", pw)
ev("[...document.querySelectorAll('button')].find(b=>/log in/i.test(b.innerText)).click()")
time.sleep(10)
print(ev("location.href"))
print(ev("document.body.innerText.slice(0,500)"))
