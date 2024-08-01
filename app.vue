<script setup lang="ts">
useHead({
    titleTemplate: (titleChunk) => {
        return titleChunk ? `${titleChunk} @ wikifeet-nuxt` : "wikiFeetNuxt";
    },
    meta: [
        {
            property: "description",
            content: "A modern frontend for wikiFeet that works everywhere",
        },
        {
            property: "lang",
            content: "en",
        },
        {
            property: "theme-color",
            content: "#f43f5e",
        },
    ],
    link: [
        {
            rel: "icon",
            type: "image/png",
            href: "/favicon.png",
        },
    ],
});
</script>

<template>
    <NuxtLayout>
        <NuxtPage></NuxtPage>
    </NuxtLayout>
</template>
