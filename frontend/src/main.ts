import { setupGenerateButton } from './generate-button'
import { setupStartImage } from './start-image'
import './style.css'

const startImageArea = document.getElementById('start-image-area') as HTMLDivElement
const startImageInput = document.getElementById('start-image-input') as HTMLInputElement
const startImagePreview = document.getElementById('start-image-preview') as HTMLImageElement
const videoPreview = document.getElementById('video-preview') as HTMLVideoElement
const generateButton = document.getElementById('generate-button') as HTMLButtonElement

setupStartImage(startImageArea, startImageInput, startImagePreview, generateButton)
setupGenerateButton(generateButton, startImagePreview, videoPreview)