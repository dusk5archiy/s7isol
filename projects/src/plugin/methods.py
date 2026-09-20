from __future__ import annotations

from typing import TYPE_CHECKING

from loguru import logger

if TYPE_CHECKING:
    from .main import Plugin


def __call__(self: Plugin):
    config = self.config
    logger.info(config.message)
