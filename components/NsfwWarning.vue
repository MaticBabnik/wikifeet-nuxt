<script lang="ts" setup>
const allowNsfw = useCookie<boolean>("nsfw", { default: () => false });

function acceptNsfw() {
    allowNsfw.value = true;
}

defineProps<{
    maybeNsfw?: boolean
}>(); 
</script>

<template>
    <div class="flex w-full flex-col items-center justify-center gap-1 min-h-96">
        <h1 class="text-red-700 dark:text-red-300 text-4xl">
            <UIcon name="i-uil-18-plus" size="48px" class="text-red-500 align-middle" />
            NSFW page{{ maybeNsfw ? '*' : '' }}
        </h1>

        <p v-if="maybeNsfw" class="my-4 max-w-96 text-center">
            men.wikifeet.com pages might be NSFW
        </p>

        <p class="my-4 max-w-96 text-center">
            NSFW means "Not Safe For Work". The content on this page may be
            inappropriate to view in some situations.
        </p>

        <div class="flex gap-2">
            <UButton size="xl" icon="i-heroicons-arrow-right-circle" @click="acceptNsfw">
                Continue
            </UButton>
            <UButton size="xl" icon="i-heroicons-home" variant="outline" to="/">
                Home
            </UButton>
        </div>
    </div>
</template>

<style></style>
