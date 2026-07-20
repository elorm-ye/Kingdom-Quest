import MainLayout from '@/components/layout/MainLayout'
import EventsPage from '@/components/pages/EventsPage'

export const metadata = { title: 'Events' }

export default function Page() {
  return <MainLayout><EventsPage /></MainLayout>
}
