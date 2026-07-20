import MainLayout from '@/components/layout/MainLayout'
import ProfilePage from '@/components/pages/ProfilePage'

export const metadata = { title: 'My Profile' }

export default function Page() {
  return <MainLayout><ProfilePage /></MainLayout>
}
