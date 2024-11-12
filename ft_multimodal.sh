#!/bin/bash
#SBATCH -J equiav_multimodal       # Job name
#SBATCH --ntasks=1                 # Number of tasks
#SBATCH --cpus-per-task=8          # Number of CPU cores per task
#SBATCH --nodes=1                  # Ensure that all cores are on the same machine with nodes=1
#SBATCH --partition=2080-galvani   # Which partition will run your job
#SBATCH --time=0-12:00             # Allowed runtime in D-HH:MM
#SBATCH --gres=gpu:8               # (optional) Requesting type and number of GPUs
#SBATCH --mem=50G                  # Total memory pool for all cores (see also --mem-per-cpu); exceeding this number will cause your job to fail.
#SBATCH --output=$WORK/logs/sbatch/equiav_multimodal-%j.out       # File to which STDOUT will be written - make sure this is not on $HOME
#SBATCH --error=$WORK/logs/sbatch/equiav_multimodal-%j.err        # File to which STDERR will be written - make sure this is not on $HOME
#SBATCH --mail-type=END,FAIL       # Type of email notification- END,FAIL
#SBATCH --mail-user=thaddaeus.wiedemer@gmail.com # Email to which notifications will be sent

source ~/.bashrc
conda activate equiAV

cd $WORK/code/avd/models/equiav
python ft_main.py \
    --gpu '0,1,2,3,4,5,6,7' \
    --model 'ft_EquiAV' \
    --dataset 'VGGSound' \
    --pretrained_model /home/bethge/twiedemer43/code/avd/checkpoints/equiav/equiav_pretrained.pth \
    --max_epoch 50 \
    --warmup_epoch 1 \
    --batch_size 32 \
    --trainfunc_ft bceloss \
    --lr 1e-4 \
    --ftmode multimodal \
    --save_path /home/bethge/twiedemer43/code/avd/checkpoints/equiav/equiav_ft_multimodal.pth \
    --no_wandb

conda deactivate