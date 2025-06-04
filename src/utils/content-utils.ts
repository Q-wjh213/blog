import { getCollection } from "astro:content";
import I18nKey from "@i18n/i18nKey";
import { i18n } from "@i18n/translation";
import { getCategoryUrl } from "@utils/url-utils.ts";

export async function getSortedPosts() {
	// Get both regular posts and typst posts
	const allBlogPosts = await getCollection("posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});
	
	const allTypstPosts = await getCollection("typst-posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});

	// Combine both collections
	const allPosts = [...allBlogPosts, ...allTypstPosts];

	const sorted = allPosts.sort((a, b) => {
		// Handle different date field names: 'published' for posts, 'date' for typst-posts
		const dateA = new Date(a.data.published || a.data.date);
		const dateB = new Date(b.data.published || b.data.date);
		return dateA > dateB ? -1 : 1;
	});

	for (let i = 1; i < sorted.length; i++) {
		sorted[i].data.nextSlug = sorted[i - 1].slug;
		sorted[i].data.nextTitle = sorted[i - 1].data.title;
	}
	for (let i = 0; i < sorted.length - 1; i++) {
		sorted[i].data.prevSlug = sorted[i + 1].slug;
		sorted[i].data.prevTitle = sorted[i + 1].data.title;
	}

	return sorted;
}

export type Tag = {
	name: string;
	count: number;
};

export async function getTagList(): Promise<Tag[]> {
	// Get tags from both collections
	const allBlogPosts = await getCollection<"posts">("posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});
	
	const allTypstPosts = await getCollection<"typst-posts">("typst-posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});

	const allPosts = [...allBlogPosts, ...allTypstPosts];

	const countMap: { [key: string]: number } = {};
	allPosts.map((post: { data: { tags: string[] } }) => {
		post.data.tags.map((tag: string) => {
			if (!countMap[tag]) countMap[tag] = 0;
			countMap[tag]++;
		});
	});

	// sort tags
	const keys: string[] = Object.keys(countMap).sort((a, b) => {
		return a.toLowerCase().localeCompare(b.toLowerCase());
	});

	return keys.map((key) => ({ name: key, count: countMap[key] }));
}

export type Category = {
	name: string;
	count: number;
	url: string;
};

export async function getCategoryList(): Promise<Category[]> {
	// Get categories from both collections
	const allBlogPosts = await getCollection<"posts">("posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});
	
	const allTypstPosts = await getCollection<"typst-posts">("typst-posts", ({ data }) => {
		return import.meta.env.PROD ? data.draft !== true : true;
	});

	const allPosts = [...allBlogPosts, ...allTypstPosts];
	
	const count: { [key: string]: number } = {};
	allPosts.map((post: { data: { category: string | null } }) => {
		if (!post.data.category) {
			const ucKey = i18n(I18nKey.uncategorized);
			count[ucKey] = count[ucKey] ? count[ucKey] + 1 : 1;
			return;
		}

		const categoryName =
			typeof post.data.category === "string"
				? post.data.category.trim()
				: String(post.data.category).trim();

		count[categoryName] = count[categoryName] ? count[categoryName] + 1 : 1;
	});

	const lst = Object.keys(count).sort((a, b) => {
		return a.toLowerCase().localeCompare(b.toLowerCase());
	});

	const ret: Category[] = [];
	for (const c of lst) {
		ret.push({
			name: c,
			count: count[c],
			url: getCategoryUrl(c),
		});
	}
	return ret;
}
