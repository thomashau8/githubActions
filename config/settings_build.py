# config/settings_build.py
# needed to bypass using secret variables in dockerfile (even dummy keys)
# in order to run collect static
# potentially change in future(?)
# config/settings_build.py
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = "dummy-build-key"
DEBUG = False

INSTALLED_APPS = [
    "django.contrib.staticfiles",
    "my_project",
]

STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"

STATICFILES_STORAGE = "django.contrib.staticfiles.storage.StaticFilesStorage"
