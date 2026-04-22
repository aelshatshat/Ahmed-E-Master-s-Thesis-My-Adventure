# File: CameraSettings.gd
extends Node2D

@export var zoom: Vector2 = Vector2(1, 1)
@export var offset: Vector2 = Vector2(0, 0)
@export var limit_left: float = -INF
@export var limit_right: float = INF
@export var limit_top: float = -INF
@export var limit_bottom: float = INF
