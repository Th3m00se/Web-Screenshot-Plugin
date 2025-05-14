import sys
from selenium import webdriver
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options
from webdriver_manager.firefox import GeckoDriverManager
import time

def take_screenshot(url, filename):
    firefox_options = Options()
    firefox_options.add_argument("--headless")

    service = Service(GeckoDriverManager().install())
    driver = webdriver.Firefox(service=service, options=firefox_options)

    try:
        driver.get(url)
        time.sleep(1)  # Wait for the page to load completely
        driver.save_screenshot(filename)
        print(f"Screenshot saved to {filename}")
    except Exception as e:
        # Convert error to string to trim it
        error_message = str(e).split('\n')[0] # Pulls the 1st line, which is normally the brief error
        print(f"Failed to take screenshot of {url}: {error_message}")
    finally:
        driver.quit()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python screenshot_selenium.py <url> <filename>")
        sys.exit(1)

    url = sys.argv[1]
    filename = sys.argv[2]
    take_screenshot(url, filename)
