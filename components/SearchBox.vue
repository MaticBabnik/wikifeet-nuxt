<template>
    <UButton
        size="lg"
        variant="outline"
        icon="i-heroicons-magnifying-glass-20-solid"
        @click="isOpen = true"
    >
        Search
        <div class="flex items-center gap-0.5">
            <UKbd>{{ metaSymbol ?? "Ctrl" }}</UKbd>
            <UKbd>K</UKbd>
        </div>
    </UButton>
    <UModal v-model="isOpen" :ui="{container:'flex min-h-full items-start-fuck-you justify-center text-center'}">
        <UCommandPalette
            @update:model-value="go"
            :groups="groups"
            :empty-state="{ icon: 'i-heroicons-magnifying-glass-20-solid', label: 'No results', queryLabel: 'No results' }"
        ></UCommandPalette>
    </UModal>
</template>

<script lang="ts" setup>
const { metaSymbol } = useShortcuts();

defineShortcuts({
    meta_k: {
        usingInput: true,
        handler: () => {
            isOpen.value = !isOpen.value;
        },
    },
});

const isOpen = ref(false);

function go({ id }: { id: string }) {
    isOpen.value = false;
    useRouter().push(`/${id}`);
}

const groups = [
    {
        key: "users",
        label: (q: string) => q && `Matching “${q}”...`,
        search: async (q: string) => {
            console.log("search ", q);
            if (!q) {
                return [];
            }

            // @ts-ignore
            const people: any[] = await $fetch("/api/search", {
                params: { q },
            });

            return people.map((person) => ({
                id: person.slug,
                label: person.name,
                suffix: person.slug,
            }));
        },
    },
];
</script>

<style>
.items-start-fuck-you {
    align-items: start !important;
}
</style>
