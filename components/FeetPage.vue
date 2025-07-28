<script lang="ts" setup>
import type { Page } from "wikifeet-js";

const route = useRoute();
const router = useRouter();
const props = defineProps<{ page: Page }>();

const ratingBars = computed(() => {
    const counts = Object.values(props.page.rating.votes);
    const max = Math.max(...counts);

    return counts.map((x) => `width: ${(x / max) * 100}%`);
});

function fixThumb(personSlug: string, pid: string) {
    return `https://pics.wikifeet.com/${personSlug}-feet-${pid}.jpg`
}

const PAGE_SIZES = [
    { id: 10, label: "10 / page" },
    { id: 25, label: "25 / page" },
    { id: 50, label: "50 / page" },
    { id: 100, label: "100 / page" },
];

const SORTS = [
    { id: "recent", label: "Recent" },
    { id: "highres", label: "Resolution" },
];

const sort = ref("recent");
const tags = ref<string[]>([]);
const pageSize = ref(50);
const galleryPage = ref(1);

const filtered = computed(() => {
    const rq = tags.value;
    if (rq.length == 0) return props.page.images;

    return props.page.images.filter((img) => {
        for (const t of rq) {
            if (!img.tags.includes(t)) return false;
        }
        return true;
    });
});

const sorted = computed(() => {
    if (sort.value == "highres")
        return filtered.value.sort(
            (a, b) =>
                b.resolution[0] * b.resolution[1] -
                a.resolution[0] * a.resolution[1]
        );

    return filtered.value.sort((a, b) => b.id - a.id);
});

const gallery = computed(() => {
    const start = pageSize.value * (galleryPage.value - 1);
    const end = start + pageSize.value;
    return sorted.value.slice(start, end);
});

// Sync state with query parameters
const syncQueryParams = () => {
    // Construct new query params based on the current state
    const queryParams = {
        s: sort.value,
        t: tags.value.length > 0 ? tags.value.join(",") : undefined,
        n: pageSize.value.toString(),
        p: galleryPage.value.toString(),
    };

    // Update the route query parameters
    router.replace({ query: { ...route.query, ...queryParams } });
};

onMounted(() => {
    const query = route.query;
    if (query.s) sort.value = query.s as string;
    if (query.t) tags.value = (query.t as string).split(",");
    if (query.n) pageSize.value = parseInt(query.n as string, 10);
    if (query.p) galleryPage.value = parseInt(query.p as string, 10);
});

watch(sort, () =>
    router.replace({
        query: {
            ...route.query,
            s: sort.value != "recent" ? sort.value : undefined,
        },
    })
);
watch(tags, () =>
    router.replace({
        query: {
            ...route.query,
            t: tags.value.length ? tags.value.join(",") : undefined,
        },
    })
);
watch(pageSize, () =>
    router.replace({
        query: {
            ...route.query,
            n: pageSize.value != 50 ? pageSize.value : undefined,
        },
    })
);
watch(galleryPage, () =>
    router.replace({
        query: {
            ...route.query,
            p: galleryPage.value != 1 ? galleryPage.value : undefined,
        },
    })
);
</script>

<template>
    <div id="top" class="flex md:flex-row flex-col justify-between">
        <div id="about" class="flex flex-col gap-1 items-start">
            <h1 class="text-4xl">{{ page.name }}</h1>

            <p>
                <span class="dark:text-gray-300 text-gray-700 font-medium"
                    >Birthday:</span
                >
                {{ page.birthDate }} ({{ page.birthplace }})
            </p>
            <p>
                <span class="dark:text-gray-300 text-gray-700 font-medium"
                    >Shoe size:</span
                >
                {{ page.shoeSize }}
            </p>
            <UButton
                :to="page.url"
                leading-icon="i-heroicons-link-16-solid"
                variant="ghost"
                size="sm"
            >
                {{ page.isNsfw ? "wikiFeetX" : "wikiFeet" }}
            </UButton>
        </div>

        <div
            id="rating"
            class="flex flex-row items-center gap-2 max-md:justify-center"
        >
            <div class="flex flex-col items-center">
                <span class="text-6xl">
                    {{ page.rating.average.toFixed(2) }}
                </span>
                <span class="text-sm"> ({{ page.rating.count }} votes) </span>
                <div class="relative w-fit">
                    <UIcon
                        v-for="_ in 5"
                        size="24px"
                        name="i-heroicons-star-solid"
                        class="text-yellow-400"
                    />
                    <div
                        class="absolute top-0 right-0 backdrop-saturate-0 h-full"
                        :style="{
                            width: `${100 - page.rating.average / 0.05}%`,
                        }"
                    >
                        <!--Desaturate-->
                    </div>
                </div>
            </div>

            <UDivider orientation="vertical" class="h-3/4" />

            <div class="flex flex-col items-start w-32 gap-1 ml-4">
                <template v-for="(style, i) in ratingBars">
                    <div class="bg-primary-500 h-3 relative" :style="style">
                        <span class="absolute bars-left text-sm">
                            {{ i + 1 }}
                        </span>
                    </div>
                </template>
            </div>
        </div>
    </div>

    <UDivider class="my-4" />

    <div
        class="flex flex-row flex-wrap gap-2 justify-between sticky top-0 bg-white dark:bg-gray-900 py-2"
    >
        <USelectMenu
            class="w-36"
            icon="i-heroicons-funnel-solid"
            placeholder="Filter"
            :options="page.tags"
            v-model="tags"
            multiple
        />

        <USelectMenu
            class="w-36"
            icon="i-heroicons-arrow-up-16-solid"
            placeholder="Sort"
            :options="SORTS"
            v-model="sort"
            value-attribute="id"
        />

        <UPagination
            v-model="galleryPage"
            :total="filtered.length"
            :page-count="pageSize"
        />

        <USelectMenu
            class="w-36"
            icon="i-heroicons-list-bullet"
            placeholder="Items/page"
            :options="PAGE_SIZES"
            v-model="pageSize"
            value-attribute="id"
        />
    </div>

    <div class="grid feetpage-grid gap-4 my-4">
        <a :href="im.image" v-for="im in gallery" :key="im.id">
            <img
                class="aspect-1 w-full object-cover rounded-md img-smooth"
                :src="im.image"
                :title="`${im.id} ${im.resolution[0]}x${im.resolution[1]}`"
            />
        </a>
    </div>

    <UDivider class="my-4" />

    <h2 class="text-2xl my-4">See also:</h2>
    <div
        id="see-also"
        class="flex flex-row gap-4 justify-center overflow-x-auto"
    >
        <ULink
            v-for="sa in page.seeAlso"
            class="rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 p-1"
            :key="sa.slug"
            :to="`/${sa.slug}`"
            draggable="false"
        >
            <img
                :src="fixThumb(sa.slug, sa.thumbs[0])"
                class="w-36 h-36 rounded-lg object-cover"
                draggable="false"
            />
            <h3 class="text-lg w-36">
                {{ sa.name }}
            </h3>
        </ULink>
    </div>
</template>

<style>
.bars-left {
    top: 50%;
    left: -1rem;
    transform: translate(0, -50%);
}

@keyframes loading-animation-e40b9399 {
    0% {
        background-position: 0% 50%;
    }

    50% {
        background-position: 100% 50%;
    }

    to {
        background-position: 0% 50%;
    }
}

.img-smooth {
    background: linear-gradient(45deg, transparent, #8884, transparent);
    background-size: 300% 300%;
    animation: loading-animation-e40b9399 1s ease infinite;
    image-rendering: optimizeQuality;
}

.feetpage-grid {
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
}
</style>
