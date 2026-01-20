function getFirstImageFile(items: DataTransferItemList | undefined) {
    if (!items) return
    const image = [...items].find((item) => item.kind === "file" && item.type.startsWith("image/"));
    if (!image) return
    return image.getAsFile();
}

async function fileToBase64String(file: File) {
    return new Promise<string>((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result as string);
        reader.onerror = () => reject(reader.error?.name as string);
        reader.readAsDataURL(file);
    })
}

async function setStartImage(file: File | null | undefined, imagePreview: HTMLImageElement, imageArea: HTMLDivElement, generateButton: HTMLButtonElement) {
    if (!file) return

    imagePreview.src = await fileToBase64String(file);

    imageArea.classList.add('hidden');
    generateButton.classList.remove('hidden');
}

export function setupStartImage(imageArea: HTMLDivElement, imageInput: HTMLInputElement, imagePreview: HTMLImageElement, generateButton: HTMLButtonElement) {
    imageArea.addEventListener('paste', async (e) => {
        const file = getFirstImageFile(e.clipboardData?.items)
        setStartImage(file, imagePreview, imageArea, generateButton)
    });

    imageArea.addEventListener("dragover", (e) => {
        e.preventDefault();
        imageArea.classList.add('active')
    });

    imageArea.addEventListener("drop", async (e) => {
        e.preventDefault();
        imageArea.classList.remove('active')

        const file = getFirstImageFile(e.dataTransfer?.items)
        setStartImage(file, imagePreview, imageArea, generateButton)
    });

    imageInput.addEventListener('change', async () => {
        const file = imageInput.files?.[0]
        setStartImage(file, imagePreview, imageArea, generateButton)
    });
}