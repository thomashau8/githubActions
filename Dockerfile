# --- Builder Stage ---
FROM python:3.12-slim AS builder

# DL3008 warning ignored here - potentially check later (wants pinned versions)
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
ARG POETRY_VERSION=2.0.1
RUN bash -o pipefail -c "curl -sSL https://install.python-poetry.org | POETRY_VERSION=${POETRY_VERSION} python3 -"
ENV PATH="/root/.local/bin:$PATH"
RUN poetry config virtualenvs.in-project true

COPY pyproject.toml poetry.lock* ./

RUN poetry install --no-interaction --no-ansi --no-root

COPY . .

ENV DJANGO_SETTINGS_MODULE=config.settings_build
RUN mkdir -p /app/staticfiles && \
    poetry run python manage.py collectstatic --noinput --clear

# RUN poetry run python -m compileall .


# --- Production Stage ---
FROM python:3.12-slim AS production
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
      libpq5 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ARG USER=appuser
ARG GROUP=appgroup
RUN addgroup --system ${GROUP} && adduser --system --ingroup ${GROUP} ${USER}

WORKDIR /app

COPY --from=builder --chown=${USER}:${GROUP} /app/.venv /app/.venv

COPY --from=builder --chown=${USER}:${GROUP} /app /app

COPY --from=builder --chown=${USER}:${GROUP} /app/staticfiles /app/staticfiles

RUN chmod +x /app/entrypoint.sh

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=config.settings \
    PORT=8000

USER ${USER}

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]