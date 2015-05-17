# filtersSwitchs = [
#   true
#   false
#   false
#   false
#   false
#   false
#   false
#   false
#   false
#   false
#   false
# ]

#//
# displacementTexture = PIXI.Texture.fromImage('images/displacement_map.jpg')
# displacementFilter = new (PIXI.DisplacementFilter)(displacementTexture)
# displacementFolder = gui.addFolder('Displacement')
# displacementFolder.add(filtersSwitchs, '0').name 'apply'
# displacementFolder.add(displacementFilter.scale, 'x', 1, 200).name 'scaleX'
# displacementFolder.add(displacementFilter.scale, 'y', 1, 200).name 'scaleY'
#
# blurFilter = new (PIXI.BlurFilter)
# blurFolder = gui.addFolder('Blur')
# blurFolder.add(filtersSwitchs, '1').name 'apply'
# blurFolder.add(blurFilter, 'blurX', 0, 32).name 'blurX'
# blurFolder.add(blurFilter, 'blurY', 0, 32).name 'blurY'
# #//
# pixelateFilter = new (PIXI.PixelateFilter)
# pixelateFolder = gui.addFolder('Pixelate')
# pixelateFolder.add(filtersSwitchs, '2').name 'apply'
# pixelateFolder.add(pixelateFilter.size, 'x', 1, 32).name 'PixelSizeX'
# pixelateFolder.add(pixelateFilter.size, 'y', 1, 32).name 'PixelSizeY'
# #//
# invertFilter = new (PIXI.InvertFilter)
# invertFolder = gui.addFolder('Invert')
# invertFolder.add(filtersSwitchs, '3').name 'apply'
# invertFolder.add(invertFilter, 'invert', 0, 1).name 'Invert'
# #//
# twistFilter = new (PIXI.TwistFilter)
# twistFolder = gui.addFolder('Twist')
# twistFolder.add(filtersSwitchs, '4').name 'apply'
# twistFolder.add(twistFilter, 'angle', 0, 10).name 'Angle'
# twistFolder.add(twistFilter, 'radius', 0, 1).name 'Radius'
# twistFolder.add(twistFilter.offset, 'x', 0, 1).name 'offset.x'
# twistFolder.add(twistFilter.offset, 'y', 0, 1).name 'offset.y'
# #//
#
# filterCollection = [
#   displacementFilter
#   blurFilter
#   pixelateFilter
#   invertFilter
#   twistFilter
# ]

# displacementFilter.scale.x = 0
# displacementFilter.scale.y = 0

# filtersToApply = []
# i = 0
# while i < filterCollection.length
#   if filtersSwitchs[i]
#     filtersToApply.push filterCollection[i]
#   i++
# pondContainer.filters = if filtersToApply.length > 0 then filtersToApply else null
