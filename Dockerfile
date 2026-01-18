# start from a clean base image (replace <version> with the desired release)
FROM runpod/worker-comfyui:5.7.1-base

# install custom nodes using comfy-cli
RUN comfy-node-install comfyui-kjnodes comfyui-videohelpersuite ComfyUI-WanVideoWrapper

# download models using comfy-cli
# the "--filename" is what you use in your ComfyUI workflow
# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_2-I2V-A14B-HIGH_bf16.safetensors --relative-path models/diffusion_models --filename Wan2_2-I2V-A14B-HIGH_bf16.safetensors
# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_2-I2V-A14B-LOW_bf16.safetensors --relative-path models/diffusion_models --filename Wan2_2-I2V-A14B-LOW_bf16.safetensors 
# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors --relative-path models/vae --filename Wan2_1_VAE_bf16.safetensors

# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors --relative-path models/text_encoders --filename umt5-xxl-enc-bf16.safetensors

# RUN comfy model download --url https://huggingface.co/lightx2v/Wan2.2-Distill-Loras/resolve/main/wan2.2_i2v_A14b_high_noise_lora_rank64_lightx2v_4step_1022.safetensors --relative-path models/loras --filename wan2.2_i2v_A14b_high_noise_lora_rank64_lightx2v_4step_1022.safetensors
# RUN comfy model download --url https://huggingface.co/lightx2v/Wan2.2-Distill-Loras/resolve/main/wan2.2_i2v_A14b_low_noise_lora_rank64_lightx2v_4step_1022.safetensors --relative-path models/loras --filename wan2.2_i2v_A14b_low_noise_lora_rank64_lightx2v_4step_1022.safetensors

# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_HIGH_lora_rank_128_fp16.safetensors --relative-path models/loras --filename SVI_v2_PRO_Wan2.2-I2V-A14B_HIGH_lora_rank_128_fp16.safetensors
# RUN comfy model download --url https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_LOW_lora_rank_128_fp16.safetensors --relative-path models/loras --filename SVI_v2_PRO_Wan2.2-I2V-A14B_LOW_lora_rank_128_fp16.safetensors

