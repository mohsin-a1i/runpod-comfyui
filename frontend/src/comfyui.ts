import workflow from "./workflow-wan22-svi.json";

const headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + import.meta.env.VITE_RUNPOD_SECRET_KEY
}

const RUNPOD_POLL_DELAY = import.meta.env.VITE_RUNPOD_POLL_DELAY || 10000

export async function imageToVideo(base64Image: string, onVideo: (base64Video: string) => void) {
    const response = await fetch(import.meta.env.VITE_RUNPOD_SERVER_URL + "run", {
        method: "POST",
        headers,
        body: JSON.stringify({
            input : {
                workflow: workflow,
                images: [{
                    name: "input.png",
                    image: base64Image
                }]
            }
        })
    });
    if (!response.ok) throw new Error(await response.text());

    const data = await response.json();
    if (["IN_QUEUE", "IN_PROGRESS"].includes(data.status)) {
        setTimeout(() => manageJob(data.id, onVideo), RUNPOD_POLL_DELAY);
    }
}

async function manageJob(jobId: string, onVideo: (base64Video: string) => void) {
    const response = await fetch(import.meta.env.VITE_RUNPOD_SERVER_URL + "status/" + jobId, {
        method: "GET",
        headers,
    })
    if (!response.ok) throw new Error(await response.text())
    const data = await response.json()

    if ("COMPLETED" === data.status) {
        const base64Video = data.output.images[0].data
        onVideo("data:video/webm;base64," + base64Video)
    } else if (["IN_QUEUE", "IN_PROGRESS"].includes(data.status)) {
        setTimeout(() => manageJob(data.id, onVideo), RUNPOD_POLL_DELAY);
    }
}