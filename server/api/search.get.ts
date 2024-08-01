import { search } from "wikifeet-js";
import { z } from "zod";

const searchSchema = z.object({
    q: z.string(),
});

export default defineEventHandler(async (event) => {
    const query = await getValidatedQuery(event, (x) => searchSchema.parse(x));

    return search(query.q);
});
