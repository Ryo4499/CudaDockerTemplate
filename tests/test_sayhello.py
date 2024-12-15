from src.mypackage.sayhello import say_hello


def test_say_hello(capfd):
    say_hello()
    out, err = capfd.readouterr()
    assert out == "Hello from mypackage!\n"
    assert err == ""
