from src.engine.engine import *

import src.apps.stars
import src.apps.sandbox
import src.apps.graphics2d
import src.apps.graphics3d

import profile

apps = {
    'stars': src.apps.stars,
    'graphics2d': src.apps.graphics2d,
    'graphics3d': src.apps.graphics3d,
    'sandbox': src.apps.sandbox
}

Engine(apps).run(config.app_name)
