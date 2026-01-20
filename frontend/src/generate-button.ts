import { imageToVideo } from "./comfyui"

export function setupGenerateButton(generateButton: HTMLButtonElement, startImagePreview: HTMLImageElement, videoPreview: HTMLVideoElement) {
    const icon = generateButton.querySelector('.fa-solid')

    generateButton.addEventListener("click", () => {
        imageToVideo(startImagePreview.src, (base64Video) => {
            startImagePreview.classList.add('hidden')

            videoPreview.src = base64Video
            videoPreview.load()
            videoPreview.classList.remove('hidden')

            icon?.classList.remove('fa-spinner', 'fa-spin')
            icon?.classList.add('fa-play')
            generateButton.disabled = false
        })
        
        icon?.classList.remove('fa-play')
        icon?.classList.add('fa-spinner', 'fa-spin')
        generateButton.disabled = true
    })
}