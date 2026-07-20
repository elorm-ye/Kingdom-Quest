import MainLayout from '@/components/layout/MainLayout'
import PrayerRequestsPage from '@/components/pages/PrayerRequestsPage'

export const metadata = { title: 'Prayer Requests' }

export default function Page() {
  return <MainLayout><PrayerRequestsPage /></MainLayout>
}
