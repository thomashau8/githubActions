import pytest
from django.test import Client


@pytest.mark.django_db
def test_homepage():
    client = Client()
    response = client.get("/")
    assert response.status_code == 200

    html = response.content.decode()
    assert "<h2>Welcome!" in html
    assert "Your app is up and running." in html
