import MainLayout from '@/components/layout/MainLayout'
import HomePage from '@/components/pages/HomePage'

export const metadata = { title: 'Home' }

export default function Page() {
  return <MainLayout><HomePage /></MainLayout>
}
