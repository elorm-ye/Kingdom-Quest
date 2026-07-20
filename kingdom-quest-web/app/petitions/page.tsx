import MainLayout from '@/components/layout/MainLayout'
import PetitionsPage from '@/components/pages/PetitionsPage'

export const metadata = { title: 'Petitions' }

export default function Page() {
  return <MainLayout><PetitionsPage /></MainLayout>
}
