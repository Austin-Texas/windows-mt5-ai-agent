import os
import sys
import time
import MetaTrader5 as mt5

POLL_SECONDS = int(os.getenv("MT5_POLL_SECONDS", "5"))

def connect():
    if not mt5.initialize():
        raise RuntimeError(f"MT5 initialize failed: {mt5.last_error()}")
    account = mt5.account_info()
    if account is None:
        raise RuntimeError(f"MT5 account unavailable: {mt5.last_error()}")
    # MetaTrader ACCOUNT_TRADE_MODE_DEMO == 0.
    if int(account.trade_mode) != 0:
        raise RuntimeError("SAFETY LOCK: this Preview agent only permits an MT5 DEMO account.")
    return account

def main():
    print("Hastenload Windows MT5 Preview Agent starting...", flush=True)
    while True:
        try:
            account = connect()
            print(
                f"MT5 DEMO connected | login={account.login} "
                f"server={account.server} balance={account.balance} equity={account.equity}",
                flush=True,
            )
        except Exception as exc:
            print(f"Agent error: {exc}", file=sys.stderr, flush=True)
        finally:
            mt5.shutdown()
        time.sleep(POLL_SECONDS)

if __name__ == "__main__":
    main()
