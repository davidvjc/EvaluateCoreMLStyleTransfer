# To use Python 3.6.5 first use command line: conda activate py36
# does not work with Python 3.7

### MODEL CONVERSION
import turicreate as tc

tc.config.set_num_gpus(1)

model = tc.load_model('MyModel.model') # update name here

model.export_coreml('MyModel.mlmodel')

