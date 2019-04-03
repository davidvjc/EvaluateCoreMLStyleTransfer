import turicreate as tc

tc.config.set_num_gpus(1)

styles = tc.load_images('styles/')
content = tc.load_images('content/')

# create Style Transfer model
model = tc.style_transfer.create(styles, content, max_iterations=100)


# save model
model.save('dog_style_model3.model')

# load model
model = tc.load_model('dog_style_model3.model')

# load test images
test_images = tc.load_images('dogs/')

# stylize test set
stylized_images = model.stylize(test_images)

stylized_images.explore()

# we can target specific images and styles

# first style
#stylized_image = model.stylize(test_images, style=0)

# subset of styles
# stylized_images = model.stylize(test_images, style=[1, 2])

monet_images = model.stylize(test_images, style=0)

monet_images.explore()



# tc.config.set_num_gpus(1)

# # Load the style and content images
# styles = tc.load_images('style/')
# content = tc.load_images('content/')

# # Create a StyleTransfer model
# model = tc.style_transfer.create(styles, content)

# # Load some test images
# test_images = tc.load_images('test/')

# # Stylize the test images
# stylized_images = model.stylize(test_images)

# stylized_images.explore()

# # Save the model for later use in Turi Create
# model.save('mymodel.model')

# Export for use in Core ML
# model.export_coreml('MyStyleTransfer.mlmodel')