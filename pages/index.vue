<script lang="ts" setup>

useHead({
    title: 'Home',
})
</script>

<template>
    <div class="h-48 flex flex-col items-center justify-center">
        <h1 class="text-6xl">
            <span
                class="bg-gradient-to-r from-pink-500 via-rose-500 to-red-500 inline-block text-transparent bg-clip-text font-bold big-shadow"
            >
                wikifeet </span
            >-nuxt
        </h1>
        <p>A modern frontend for wikiFeet that works <i>everywhere</i></p>
    </div>

    <div class="h-48 flex flex-row items-center justify-evenly text-center">
        <div class="flex flex-col items-center w-36">
            <UIcon
                name="i-heroicons-cog"
                size="3rem"
                class="bg-gradient-to-r from-pink-500 via-rose-500 to-red-500"
            />
            <h2 class="text-2xl font-bold">Modern</h2>
            <p>...</p>
        </div>
        <div class="flex flex-col items-center w-36">
            <UIcon
                name="i-heroicons-globe-europe-africa"
                size="3rem"
                class="bg-gradient-to-r from-pink-500 via-rose-500 to-red-500"
            />
            <h2 class="text-2xl font-bold">Unrestricted</h2>
            <p>thx EU</p>
        </div>
        <div class="flex flex-col items-center w-36">
            <UIcon
                name="i-heroicons-code-bracket"
                size="3rem"
                class="bg-gradient-to-r from-pink-500 via-rose-500 to-red-500"
            />
            <h2 class="text-2xl font-bold">FOSS</h2>
            <p>Free as in freedom</p>
        </div>
    </div>
</template>

<style>
.big-shadow {
    filter: drop-shadow(0 0 2rem #ef4644ff);
}
</style>
