import { page } from "wikifeet-js";

export default defineEventHandler(async (event) => {
    const slug = getRouterParam(event, "slug") as string;

    return page(slug);
});
