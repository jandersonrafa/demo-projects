import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity()
export class Bonus {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({
        type: 'decimal',
        precision: 15,
        scale: 2,
        transformer: {
            to: (value: number) => value,
            from: (value: any) => value !== null ? parseFloat(value) : null
        }
    })
    amount: number;

    @Column()
    description: string;

    @Column({ name: 'client_id' })
    clientId: string;

    @CreateDateColumn({ name: 'created_at' })
    createdAt: Date;

    @Column({ name: 'expiration_date', nullable: true })
    expirationDate: Date;
}
