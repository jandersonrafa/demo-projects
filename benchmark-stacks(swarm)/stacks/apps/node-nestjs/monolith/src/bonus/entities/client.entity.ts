import { Entity, Column, PrimaryColumn } from 'typeorm';

@Entity('clients')
export class Client {
    @PrimaryColumn()
    id: string;

    @Column()
    name: string;

    @Column({ default: true })
    active: boolean;
}
