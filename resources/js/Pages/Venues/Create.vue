<script setup>
import {Head, Link, useForm} from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';

const form = useForm({
    venue_name: '',
    venue_address: '',
    venue_max_capacity: '',
    venue_image: null,
    imagePreview: null,
});

const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.venue_image = file;
        form.imagePreview = URL.createObjectURL(file);
    }
};

const submit = () => {
    form.post(route('venues.store'), {
        forceFormData: true,
    });
};
</script>

<template>
    <Head title="Create Venue"/>

    <AppLayout>
        <template #header>
            <div class="flex justify-between items-center">
                <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">Create Venue</h2>
                <Link :href="route('venues.index')"
                      class="px-4 py-2 bg-gray-800 dark:bg-gray-700 text-white rounded-md hover:bg-gray-700 dark:hover:bg-gray-600">
                    Back to Venues
                </Link>
            </div>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-xl sm:rounded-lg">
                    <div class="p-6">
                        <form @submit.prevent="submit">
                            <div class="mb-4">
                                <InputLabel for="venue_name" value="Venue Name" class="dark:text-gray-300"/>
                                <TextInput
                                    id="venue_name"
                                    type="text"
                                    class="mt-1 block w-full"
                                    v-model="form.venue_name"
                                    required
                                    autofocus
                                />
                                <InputError class="mt-2" :message="form.errors.venue_name"/>
                            </div>

                            <div class="mb-4">
                                <InputLabel for="venue_address" value="Venue Address" class="dark:text-gray-300"/>
                                <TextInput
                                    id="venue_address"
                                    type="text"
                                    class="mt-1 block w-full"
                                    v-model="form.venue_address"
                                    required
                                />
                                <InputError class="mt-2" :message="form.errors.venue_address"/>
                            </div>

                            <div class="mb-4">
                                <InputLabel for="venue_max_capacity" value="Maximum Capacity"
                                            class="dark:text-gray-300"/>
                                <TextInput
                                    id="venue_max_capacity"
                                    type="number"
                                    class="mt-1 block w-full"
                                    v-model="form.venue_max_capacity"
                                    required
                                    min="1"
                                />
                                <InputError class="mt-2" :message="form.errors.venue_max_capacity"/>
                            </div>

                            <div class="mb-4">
                                <InputLabel for="venue_image" value="Venue Image" class="dark:text-gray-300"/>
                                <input
                                    id="venue_image"
                                    type="file"
                                    class="mt-1 block w-full text-sm text-gray-500 dark:text-gray-400
                                           file:mr-4 file:py-2 file:px-4
                                           file:rounded-md file:border-0
                                           file:text-sm file:font-semibold
                                           file:bg-indigo-50 file:text-indigo-700
                                           dark:file:bg-indigo-900 dark:file:text-indigo-300
                                           hover:file:bg-indigo-100 dark:hover:file:bg-indigo-800"
                                    @change="handleImageChange"
                                    accept="image/*"
                                />
                                <InputError class="mt-2" :message="form.errors.venue_image"/>
                            </div>

                            <div v-if="form.imagePreview" class="mb-4">
                                <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">Preview:</p>
                                <img :src="form.imagePreview" alt="Venue Image Preview" class="w-48 h-48 object-cover rounded-md">
                            </div>

                            <div class="flex items-center justify-end mt-4">
                                <PrimaryButton class="ml-4" :class="{ 'opacity-25': form.processing }"
                                               :disabled="form.processing">
                                    Create Venue
                                </PrimaryButton>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
