import MainLayout from '@/components/layout/MainLayout'
import AdminPage from '@/components/pages/admin/AdminPage'

export const metadata = { title: 'Admin Dashboard' }

export default function Page() {
  return <MainLayout><AdminPage /></MainLayout>
}
