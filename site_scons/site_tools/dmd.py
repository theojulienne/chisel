# imports the default SCons DMD tool, but adds support for ldmd
import SCons.Tool.dmd
import os

def generate(env):
	dc = env.Detect(['dmd', 'gdmd', 'ldmd'])
	SCons.Tool.dmd.generate( env )
	env['DC'] = dc

def exists(env):
	return env.Detect(['dmd', 'gdmd', 'ldmd'])