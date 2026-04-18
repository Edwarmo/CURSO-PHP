<script setup>
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';

defineProps({
    events: Array,
});

const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>

<template>
    <AppLayout title="Dashboard">
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
                Eventos Activos
            </h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div v-if="events.length === 0" class="text-center py-12">
                    <p class="text-gray-500 dark:text-gray-400 text-lg">
                        No hay eventos activos disponibles.
                    </p>
                </div>
                <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div v-for="event in events" :key="event.id_event"
                         class="bg-white dark:bg-gray-800 rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
                        <div class="h-48 w-full overflow-hidden">
                            <img v-if="event.venue && event.venue.venue_image"
                                 :src="'/storage/' + event.venue.venue_image"
                                 :alt="event.venue.venue_name"
                                 class="w-full h-full object-cover" />
                            <div v-else class="w-full h-full bg-gray-300 dark:bg-gray-700 flex items-center justify-center">
                                <span class="text-gray-500 dark:text-gray-400">Sin imagen</span>
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                                {{ event.event_name }}
                            </h3>
                            <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">
                                <span class="font-medium">Fecha:</span> {{ formatDate(event.event_date) }}
                            </p>
                            <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">
                                <span class="font-medium">Lugar:</span> {{ event.venue ? event.venue.venue_name : 'Sin venue' }}
                            </p>
                            <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">
                                <span class="font-medium">Capacidad:</span> {{ event.event_max_capacity }} personas
                            </p>
                            <p v-if="event.event_speaker_name" class="text-sm text-gray-600 dark:text-gray-300 mb-3">
                                <span class="font-medium">Ponente:</span> {{ event.event_speaker_name }}
                            </p>
                            <Link :href="route('events.show', event.id_event)"
                                  class="inline-block mt-2 px-4 py-2 bg-indigo-600 dark:bg-indigo-700 text-white text-sm rounded-md hover:bg-indigo-700 dark:hover:bg-indigo-600 transition-colors">
                                Ver detalles
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
