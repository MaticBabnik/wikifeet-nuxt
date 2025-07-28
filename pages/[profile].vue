<script lang="ts" setup>
const route = useRoute();
const allowNsfw = useCookie<boolean>("nsfw", { default: () => false });

const { data, status, error } = useAsyncData(
    route.params.profile as string,
    () => $fetch(`/api/profile/${route.params.profile}`)
);

useSeoMeta({
    title: data.value?.name,
    ogTitle: data.value?.name,
    ogImage: data.value?.images?.sort((a, b) => b.id - a.id)?.[0]?.image,
    description() {
        if (!data.value) return;
        return `Browse ${data.value.images.length} images of ${data.value.name}.`;
    },
    ogDescription() {
        if (!data.value) return;
        return `Browse ${data.value.images.length} images of ${data.value.name}.`;
    },
});
</script>

<template>
    <div v-if="status == 'pending'" class="min-h-48 flex flex-col items-center justify-center">
        Loading
        <UProgress animation="carousel" />
    </div>
    <div v-else-if="status == 'error'">
        <pre>{{ error }}</pre>
    </div>
    <NsfwWarning v-else-if="(data?.isNsfw || data?.isPotentiallyNsfw) && !allowNsfw"
        :maybe-nsfw="data?.isPotentiallyNsfw && !data?.isNsfw" />
    <FeetPage v-else :page="data!" />
    <div></div>
</template>

<style></style>
