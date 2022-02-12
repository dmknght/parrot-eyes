from parrot_eyes import eyes_watcher


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    watcher = eyes_watcher.EyesWatcher()
    watcher.setup_default_callback()
    watcher.run()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
