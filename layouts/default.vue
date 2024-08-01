<script lang="ts" setup>
const colorMode = useColorMode();
const isDark = computed({
    get() {
        return colorMode.value === "dark";
    },
    set() {
        colorMode.preference = colorMode.value === "dark" ? "light" : "dark";
    },
});
</script>

<template>
    <UContainer>
        <UCard class="mt-4">
            <template #header>
                <div class="flex items-center gap-2">
                    <ULink to="/">
                        <h1>
                            <span class="text-primary-400 font-bold">
                                wikiFeet</span
                            >-nuxt
                        </h1>
                    </ULink>

                    <div class="flex-1"></div>

                    <SearchBox />

                    <ClientOnly>
                        <UButton
                            :icon="
                                isDark
                                    ? 'i-heroicons-moon-20-solid'
                                    : 'i-heroicons-sun-20-solid'
                            "
                            color="gray"
                            variant="ghost"
                            aria-label="Theme"
                            @click="isDark = !isDark"
                        />
                        <template #fallback>
                            <div class="w-8 h-8" />
                        </template>
                    </ClientOnly>
                </div>
            </template>

            <template #default>
                <slot />
            </template>

            <template #footer>
                <div class="flex flex-row justify-around">
                    <a class="underline text-primary-500" href="#">wikiFeet</a>
                    <a
                        class="underline text-primary-500 font-mono"
                        href="https://github.com/MaticBabnik/wikifeet-nuxt"
                        >wikifeet-nuxt</a
                    >
                    <a
                        class="underline text-primary-500 font-mono"
                        href="https://github.com/MaticBabnik/wikifeet-js"
                        >wikifeet-js</a
                    >
                </div>
                <span class="text-center w-full block text-gray-500">
                    This site does not store any content on its server. <br> 
                    All media is provided by wikiFeet(X).
                </span>
            </template>
        </UCard>
    </UContainer>
</template>

<style>
.tabs-icon-only span.mr-2 {
    margin: 0 !important;
}

.tabs-no-content > :last-child {
    display: none;
}
</style>
